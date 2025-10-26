Absolument ! Voici un Dockerfile optimisé pour un projet Go, utilisant une approche multi-stage pour créer une image finale légère et sécurisée.

```dockerfile
# === Étape 1: Le compilateur (Builder Stage) ===
# Utilise une image Go officielle avec un tag spécifique pour la stabilité.
# golang:<version>-alpine est souvent préféré pour un compilateur plus léger,
# mais golang:<version> standard fonctionne très bien et inclut plus d'outils si nécessaire.
FROM golang:1.22.4-alpine AS builder

# Définit le répertoire de travail à l'intérieur du conteneur.
# Tous les chemins relatifs seront basés sur ce répertoire.
WORKDIR /app

# Copie les fichiers go.mod et go.sum en premier.
# Cela permet à Docker de mettre en cache la couche de téléchargement des modules.
# Si ces fichiers ne changent pas, Docker n'exécutera pas 'go mod download' à nouveau.
COPY go.mod go.sum ./

# Télécharge toutes les dépendances Go.
# Le module cache est utilisé pour accélérer les builds futurs.
RUN go mod download

# Copie le reste du code source de votre application dans le répertoire de travail.
COPY . .

# Définit des variables d'environnement pour une compilation statique.
# CGO_ENABLED=0 est crucial pour créer un binaire statique sans dépendances C,
# ce qui le rend compatible avec les images de base ultra-légères comme Alpine ou Scratch.
# GOOS=linux et GOARCH=amd64 garantissent que le binaire est compilé pour l'environnement Linux standard.
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

# Construit l'application.
# -o /usr/local/bin/<application_name> : Spécifie le chemin et le nom du binaire de sortie.
#   Remplacez <application_name> par le nom de votre exécutable (ex: "myapp").
# -ldflags "-s -w" : Réduit la taille du binaire en supprimant les tables de symboles et de débogage.
# ./cmd/<application_name> : C'est le chemin vers votre package main.
#   Ajustez-le en fonction de la structure de votre projet (ex: "./" si main.go est à la racine, "./main.go", ou "./server").
RUN go build -ldflags "-s -w" -o /usr/local/bin/myapp ./cmd/myapp

# === Étape 2: L'image d'exécution (Runner Stage) ===
# Utilise une image de base très légère pour le déploiement.
# alpine est un choix populaire car il est très petit et inclut un shell et quelques utilitaires.
# scratch serait encore plus petit mais nécessiterait de copier manuellement ca-certificates
# si votre application fait des requêtes HTTPS.
FROM alpine:latest AS runner

# Définit le répertoire de travail (optionnel mais bonne pratique).
WORKDIR /app

# Copie uniquement le binaire compilé de l'étape de construction vers l'image finale.
# C'est la clé de l'optimisation de la taille de l'image.
COPY --from=builder /usr/local/bin/myapp /usr/local/bin/myapp

# Installe les certificats SSL/TLS nécessaires.
# Ceci est essentiel si votre application Go effectue des requêtes HTTPS (ex: API externes, bases de données sécurisées).
RUN apk add --no-cache ca-certificates

# Crée un utilisateur non-root pour des raisons de sécurité.
# Exécuter l'application avec un utilisateur non-root réduit les risques en cas de vulnérabilité.
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Expose le port sur lequel l'application Go écoute.
# IMPORTANT: Assurez-vous que ce port correspond au port configuré dans votre application Go.
EXPOSE 8080

# Définit la commande à exécuter lorsque le conteneur démarre.
# ENTRYPOINT devrait pointer directement vers votre binaire.
# Utilisez la forme JSON pour que les signaux (ex: SIGTERM) soient correctement transmis à l'application.
ENTRYPOINT ["/usr/local/bin/myapp"]

# CMD peut être utilisé pour fournir des arguments par défaut à l'ENTRYPOINT,
# mais ce n'est pas toujours nécessaire si l'application gère sa configuration via des variables d'environnement.
# CMD ["--config", "/app/config.json"] # Exemple si votre app prend un argument de config
```

### Explications et Optimisations Clés :

1.  **Multi-Stage Build (`AS builder`, `FROM ... AS runner`, `COPY --from=builder`)**:
    *   **Avantage majeur**: L'image finale ne contient *que* le binaire compilé et les dépendances d'exécution minimales (comme `ca-certificates`). Elle n'inclut pas le compilateur Go, le code source complet, ni les outils de développement, ce qui réduit considérablement la taille de l'image.
    *   L'étape `builder` s'occupe de compiler l'application.
    *   L'étape `runner` est l'image finale, basée sur `alpine` pour sa petite taille.

2.  **`go.mod` et `go.sum` Copiés en Premier (`COPY go.mod go.sum ./`, `RUN go mod download`)**:
    *   Cela tire parti du système de cache de Docker. Si `go.mod` et `go.sum` ne changent pas, Docker réutilisera la couche où les modules ont été téléchargés, accélérant ainsi les builds ultérieurs.

3.  **`CGO_ENABLED=0` et compilation statique (`ENV CGO_ENABLED=0`, `go build -ldflags "-s -w"`)**:
    *   `CGO_ENABLED=0` indique au compilateur Go de ne pas lier de bibliothèques C. Cela produit un binaire entièrement statique.
    *   Un binaire statique peut être exécuté sur des images de base très minimales (comme Alpine ou même `scratch`) sans avoir à installer des bibliothèques C standard (comme `glibc` qui n'est pas présente sur Alpine).
    *   `-ldflags "-s -w"` réduit la taille du binaire en supprimant les tables de symboles et de débogage.

4.  **Image de Base Légère (`FROM alpine:latest`)**:
    *   `alpine` est une distribution Linux très petite, ce qui contribue à une image Docker finale de taille minimale.

5.  **`ca-certificates`**:
    *   Indispensable si votre application Go fait des requêtes HTTPS vers d'autres services, bases de données, etc. `alpine` n'inclut pas ces certificats par défaut.

6.  **Utilisateur non-root (`RUN addgroup ... && adduser ...`, `USER appuser`)**:
    *   Une bonne pratique de sécurité. Exécuter l'application en tant qu'utilisateur non-root réduit la surface d'attaque en cas de compromission du conteneur.

7.  **`EXPOSE` et `ENTRYPOINT`**:
    *   `EXPOSE 8080`: Documente le port attendu pour l'application. **Assurez-vous que votre application Go écoute bien sur ce port !**
    *   `ENTRYPOINT ["/usr/local/bin/myapp"]`: Définit l'exécutable principal. La forme JSON garantit que les signaux système (comme `SIGTERM` pour l'arrêt propre) sont correctement transmis à votre application.

### Fichier `.dockerignore` (très recommandé) :

Créez un fichier `.dockerignore` à la racine de votre projet pour exclure les fichiers et dossiers inutiles du contexte de build Docker. Cela accélère le processus de build et évite de copier des données superflues.

```gitignore
# Dossiers Git
.git
.gitignore

# Dossiers Docker
.dockerignore

# Dossiers Go
bin/
pkg/
vendor/ # Si vous utilisez vendor/ au lieu de go mod download directement
*.test
*.prof

# Fichiers de configuration / environnements locaux
.env
.DS_Store
*.log
tmp/
```

### Comment construire et exécuter :

1.  **Construire l'image :**
    ```bash
    docker build -t mon-app-go .
    ```
    (Remplacez `mon-app-go` par le nom souhaité pour votre image.)

2.  **Exécuter le conteneur :**
    ```bash
    docker run -p 8080:8080 mon-app-go
    ```
    Cela mappera le port 8080 de votre machine hôte au port 8080 à l'intérieur du conteneur.

Ce Dockerfile vous offre une base solide, optimisée pour la taille, la performance et la sécurité de vos applications Go conteneurisées.