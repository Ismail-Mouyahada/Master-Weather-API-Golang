Voici un Dockerfile optimisé et commenté pour un projet Go, utilisant les meilleures pratiques pour la construction d'images légères et efficaces.

Ce Dockerfile utilise une approche de **build multi-stage** pour minimiser la taille de l'image finale.

```dockerfile
# Première étape : Construction de l'application Go
# ===============================================
# Utilisation d'une image Go officielle avec Alpine Linux pour une image de construction plus légère.
# 'AS builder' nomme cette étape, permettant de copier des artefacts depuis elle plus tard.
FROM golang:1.22.2-alpine AS builder

# Définir le répertoire de travail à l'intérieur du conteneur.
# Tous les chemins relatifs suivants seront basés sur ce répertoire.
WORKDIR /app

# Copier les fichiers go.mod et go.sum en premier.
# Ceci permet à Docker de mettre en cache la couche de téléchargement des dépendances.
# Si seuls les fichiers source changent, les dépendances n'ont pas besoin d'être téléchargées à nouveau.
COPY go.mod go.sum ./

# Télécharger les dépendances du module Go.
# Le drapeau -mod=readonly garantit que le go.mod n'est pas modifié.
RUN go mod download -mod=readonly

# Copier le reste du code source de l'application.
COPY . .

# Construire l'application Go.
# - CGO_ENABLED=0: Désactive CGO, ce qui produit un binaire statiquement lié.
#                  Ceci est crucial pour une image finale minimale comme Alpine ou scratch.
# - GOOS=linux: Spécifie le système d'exploitation cible (Linux).
# - -a: Force la reconstruction de tous les packages.
# - -ldflags "-s -w": Réduit la taille du binaire en supprimant les tables de symboles (-s)
#                      et les informations de débogage DWARF (-w).
# - -o /usr/local/bin/my-app: Spécifie le chemin et le nom du binaire de sortie.
#                              Assurez-vous que './cmd/my-app' correspond au chemin de votre point d'entrée.
#                              Si votre point d'entrée est à la racine, utilisez simplement './'.
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-s -w' -o /usr/local/bin/my-app ./cmd/my-app


# Deuxième étape : Création de l'image d'exécution minimale
# =========================================================
# Utilisation d'une image Alpine Linux minimale pour l'exécution.
# C'est une image très petite, idéale pour les binaires Go statiquement liés.
FROM alpine:3.19 AS runner

# Installer ca-certificates si votre application effectue des requêtes HTTPS.
# Ceci est essentiel pour la communication TLS.
# --no-cache réduit la taille de l couche en ne stockant pas les index des paquets.
RUN apk add --no-cache ca-certificates

# Définir le répertoire de travail à l'intérieur du conteneur.
WORKDIR /app

# Créer un utilisateur non-root pour des raisons de sécurité.
# Exécuter un conteneur en tant qu'utilisateur root est une mauvaise pratique de sécurité.
# adduser -D: Crée un utilisateur système sans mot de passe ni répertoire personnel.
# -g '': Spécifie un groupe vide, l'utilisateur sera dans un groupe du même nom.
RUN adduser -D -g '' appuser

# Copier le binaire compilé depuis l'étape de construction (builder).
# Seul le binaire final est copié, pas le code source ni les outils de construction.
COPY --from=builder /usr/local/bin/my-app .

# Changer la propriété du binaire à l'utilisateur non-root.
RUN chown appuser:appuser ./my-app

# Basculer l'exécution vers l'utilisateur non-root.
USER appuser

# Exposer le port sur lequel l'application Go écoutera.
# C'est une documentation, le port n'est pas réellement publié sans le drapeau -p de 'docker run'.
EXPOSE 8080

# Définir des variables d'environnement si nécessaire (ex: le port d'écoute).
ENV PORT=8080

# Définir la commande qui sera exécutée lorsque le conteneur démarre.
# Utilisation de la forme exec pour que le processus soit PID 1, permettant
# une gestion appropriée des signaux (ex: SIGTERM).
ENTRYPOINT ["./my-app"]

# Vous pouvez ajouter un CMD si votre application accepte des arguments de ligne de commande par défaut,
# qui peuvent être écrasés par 'docker run'.
# CMD ["--config", "/etc/app/config.yaml"]
```

### Explications Détaillées et Optimisations :

1.  **Build Multi-Stage (`FROM ... AS builder`, `COPY --from=builder ...`)**:
    *   C'est l'optimisation la plus importante pour les applications Go.
    *   La première étape (`builder`) contient tout le nécessaire pour compiler l'application (le compilateur Go, les outils, les dépendances).
    *   La deuxième étape (`runner`) ne contient que le binaire Go compilé et les dépendances d'exécution minimales (comme `ca-certificates`).
    *   Cela réduit drastiquement la taille de l'image finale, car les outils de développement ne sont pas inclus.

2.  **Images de Base Appropriées (`golang:1.22.2-alpine`, `alpine:3.19`)**:
    *   `golang:1.22.2-alpine`: Image officielle Go basée sur Alpine Linux. Alpine est beaucoup plus petite que les images basées sur Debian ou Ubuntu, ce qui rend l'étape de construction plus rapide et plus légère. Il est recommandé d'utiliser une version spécifique (ex: `1.22.2`) pour la reproductibilité.
    *   `alpine:3.19`: Une image Alpine Linux très légère. Puisque le binaire Go est statiquement lié (grâce à `CGO_ENABLED=0`), il n'a pas besoin de la bibliothèque `glibc` généralement présente dans les distributions plus grandes, ce qui rend Alpine parfait.

3.  **Gestion Intelligente des Dépendances (`COPY go.mod go.sum ./`, `RUN go mod download`)**:
    *   En copiant d'abord `go.mod` et `go.sum` et en exécutant `go mod download` *avant* de copier le reste du code, Docker peut mettre en cache cette couche. Si seules les sources de votre application changent (et non les dépendances Go), cette étape ne sera pas réexécutée, accélérant ainsi les constructions futures.

4.  **Optimisation de la Compilation Go (`CGO_ENABLED=0`, `-ldflags '-s -w'`)**:
    *   `CGO_ENABLED=0`: **Essentiel** pour créer un binaire Go statiquement lié. Cela signifie que le binaire n'aura pas de dépendances C et pourra s'exécuter sur une image minimale comme `alpine` (ou même `scratch`) sans avoir besoin de bibliothèques système spécifiques comme `glibc`.
    *   `-ldflags '-s -w'`: Ces drapeaux du linker réduisent considérablement la taille du binaire final en supprimant les tables de symboles (`-s`) et les informations de débogage DWARF (`-w`).

5.  **Sécurité (`adduser`, `USER appuser`)**:
    *   Il est recommandé de ne pas exécuter votre application en tant qu'utilisateur `root` à l'intérieur du conteneur. Nous créons un utilisateur non-root (`appuser`) et exécutons l'application sous cet utilisateur. C'est une bonne pratique de sécurité.

6.  **Certificats SSL/TLS (`RUN apk add --no-cache ca-certificates`)**:
    *   Si votre application Go effectue des requêtes HTTPS vers des services externes (API, bases de données sécurisées), elle aura besoin des certificats d'autorité de certification (CA). Alpine ne les inclut pas par défaut dans sa version minimale, il faut donc les installer explicitement. Le `--no-cache` garantit que les index des paquets ne sont pas conservés, réduisant la taille de la couche.

7.  **Commande de Démarrage (`ENTRYPOINT`)**:
    *   `ENTRYPOINT ["./my-app"]`: Utilise la forme "exec" pour s'assurer que votre application est le processus PID 1 dans le conteneur. Cela permet à Docker de gérer correctement les signaux (ex: `SIGTERM` pour un arrêt gracieux) et assure que le shell ne capture pas ces signaux.

### Utilisation :

1.  Assurez-vous que le chemin de votre point d'entrée Go dans `RUN CGO_ENABLED=0 ... ./cmd/my-app` est correct. Si votre `main.go` est à la racine de votre projet, utilisez `./`.
2.  Nommez ce fichier `Dockerfile` (sans extension).
3.  Placez-le à la racine de votre projet Go.
4.  Construisez l'image :
    ```bash
    docker build -t mon-app-go:latest .
    ```
5.  Exécutez le conteneur :
    ```bash
    docker run -p 8080:8080 mon-app-go:latest
    ```