Voici le README complet et professionnel pour votre dépôt GitHub, conçu pour impressionner les recruteurs et employeurs :

---

# ☁️ Master-Weather-API-Golang: Performances Élevées et Scalabilité en Go 🚀

[![Go Version](https://img.shields.io/github/go-mod/go-version/votre-utilisateur/Master-Weather-API-Golang?style=for-the-badge&logo=go&logoColor=white&color=00ADD8)](https://golang.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Go Build](https://github.com/votre-utilisateur/Master-Weather-API-Golang/actions/workflows/go.yml/badge.svg)](https://github.com/votre-utilisateur/Master-Weather-API-Golang/actions/workflows/go.yml)
[![Go Report Card](https://goreportcard.com/badge/github.com/votre-utilisateur/Master-Weather-API-Golang?style=for-the-badge)](https://goreportcard.com/report/github.com/votre-utilisateur/Master-Weather-API-Golang)
[![Built with Go](https://img.shields.io/badge/Made%20with-Go-00ADD8.svg?style=for-the-badge&logo=go)](https://go.dev/)
[![Framework: Gin](https://img.shields.io/badge/Framework-Gin-008080.svg?style=for-the-badge&logo=go)](https://github.com/gin-gonic/gin)
[![Containerized with Docker](https://img.shields.io/badge/Containerized%20with-Docker-2496ED.svg?style=for-the-badge&logo=docker)](https://www.docker.com/)

## 📋 Description

Ce projet est une vitrine d'expertise avancée en développement backend Go, présentant une API météo RESTful ultra-performante et hautement scalable, conçue pour des environnements de production exigeants. Il valide une maîtrise approfondie de la concurrence Go (goroutines, channels), des architectures de systèmes distribués, et des principes de conception de logiciels robustes et maintenables.

L'objectif principal de cette API est de fournir des données météorologiques précises et à jour avec une latence minimale, tout en démontrant une capacité à gérer un volume élevé de requêtes simultanées de manière efficiente. Elle a été construite dans l'optique de la résilience, de la modularité et de la facilité de déploiement, en intégrant des pratiques modernes de développement logiciel. Ce projet n'est pas seulement une API météo, c'est une démonstration concrète de l'application de principes d'ingénierie logicielle de pointe pour créer des systèmes fiables et performants en Go, répondant aux exigences des infrastructures microservices contemporaines.

## ✨ Fonctionnalités

*   **API RESTful Complète :** Fournit des endpoints clairs et intuitifs pour accéder aux données météorologiques actuelles et prévisionnelles.
*   **Haute Performance & Concurrence :** Exploite pleinement les `goroutines` et les `channels` de Go pour une gestion asynchrone et non-bloquante des requêtes, garantissant une faible latence même sous forte charge.
*   **Scalabilité Horizontale :** Conçue comme une application stateless, elle peut être facilement mise à l'échelle horizontalement pour s'adapter à l'augmentation du trafic.
*   **Architecture Modulaire :** Adopte une architecture propre (Clean Architecture / Hexagonal) favorisant la séparation des préoccupations, la testabilité et la maintenabilité.
*   **Gestion Robuste des Erreurs :** Implémentation d'une gestion d'erreurs cohérente et informative via l'API.
*   **Conteneurisation Docker :** Fournit un `Dockerfile` optimisé pour un déploiement rapide et reproductible dans n'importe quel environnement conteneurisé.
*   **Configuration Environnementale :** Utilise des variables d'environnement pour une configuration flexible et sécurisée des clés d'API externes et autres paramètres.

## 🚀 Technologies utilisées

| Technologie | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| :---------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ![Go](https://img.shields.io/badge/Go-00ADD8?style=flat-square&logo=go&logoColor=white) | Le langage de programmation principal, choisi pour ses performances exceptionnelles, sa gestion native de la concurrence (`goroutines`, `channels`) qui permet de construire des systèmes distribués et hautement performants, et sa compilation en binaires statiques facilitant le déploiement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ![Gin Gonic](https://img.shields.io/badge/Gin-Gonic-008080?style=flat-square&logo=go&logoColor=white) | Un framework web HTTP ultra-rapide pour Go, utilisé pour construire les endpoints de l'API. Sa performance, sa robustesse et sa simplicité d'utilisation en font un choix idéal pour des APIs RESTful nécessitant de hautes performances.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white) | Utilisé pour conteneuriser l'application, assurant un environnement de développement et de production cohérent et isolé. Docker facilite le déploiement, la scalabilité et l'intégration continue en encapsulant l'application et toutes ses dépendances dans un package léger et portable.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ![OpenWeatherMap API](https://img.shields.io/badge/OpenWeatherMap-FF8C00?style=flat-square&logo=openweathermap&logoColor=white) | Source externe de données météorologiques. Un service tiers fiable et largement utilisé pour récupérer les informations météorologiques actuelles et prévisionnelles. L'API est conçue pour être agnostique vis-à-vis du fournisseur, permettant une substitution facile si nécessaire.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |

## 📦 Installation

Pour faire fonctionner cette API localement, suivez les étapes ci-dessous.

### Prérequis

Assurez-vous d'avoir installé :
*   [Go (version 1.18 ou supérieure)](https://golang.org/doc/install)
*   [Docker (recommandé pour la production)](https://docs.docker.com/get-docker/)

### Configuration de la Clé API

Cette API utilise la clé API d'OpenWeatherMap pour récupérer les données météo.
1.  Obtenez votre clé API gratuite depuis [OpenWeatherMap](https://openweathermap.org/api).
2.  Créez un fichier `.env` à la racine du projet ou définissez la variable d'environnement `OPENWEATHER_API_KEY` :
    ```dotenv
    OPENWEATHER_API_KEY=votre_cle_api_openweathermap
    ```

### Via Go (sans Docker)

1.  **Clonez le dépôt :**
    ```bash
    git clone https://github.com/votre-utilisateur/Master-Weather-API-Golang.git
    cd Master-Weather-API-Golang
    ```
2.  **Téléchargez les dépendances :**
    ```bash
    go mod tidy
    ```
3.  **Construisez l'application :**
    ```bash
    go build -o master-weather-api
    ```
4.  **Exécutez l'application :**
    ```bash
    ./master-weather-api
    ```
    L'API devrait maintenant être accessible sur `http://localhost:8080`.

### Via Docker (recommandé)

1.  **Clonez le dépôt :**
    ```bash
    git clone https://github.com/votre-utilisateur/Master-Weather-API-Golang.git
    cd Master-Weather-API-Golang
    ```
2.  **Construisez l'image Docker :**
    ```bash
    docker build -t master-weather-api-go .
    ```
3.  **Exécutez le conteneur Docker :**
    Assurez-vous que le fichier `.env` est présent ou que la variable d'environnement `OPENWEATHER_API_KEY` est définie sur votre machine.
    ```bash
    docker run -d -p 8080:8080 --name weather-api --env-file .env master-weather-api-go
    ```
    L'API devrait maintenant être accessible sur `http://localhost:8080`.

## 🎯 Utilisation

Une fois l'API démarrée, vous pouvez interroger les endpoints suivants :

### 1. Obtenir les conditions météorologiques actuelles par ville

*   **Endpoint:** `/weather/current`
*   **Méthode:** `GET`
*   **Paramètres de requête:**
    *   `city` (obligatoire) : Nom de la ville (e.g., `Paris`, `London`).

**Exemple de requête:**

```bash
curl -X GET "http://localhost:8080/weather/current?city=Paris"
```

**Exemple de réponse (JSON):**

```json
{
  "city": "Paris",
  "temperature": 15.5,
  "feels_like": 14.2,
  "humidity": 70,
  "description": "nuageux",
  "icon": "04d",
  "wind_speed": 4.12,
  "sunrise": "2023-10-27T07:38:00Z",
  "sunset": "2023-10-27T18:03:00Z",
  "timestamp": "2023-10-27T10:30:00Z"
}
```

### 2. Obtenir les prévisions météorologiques par ville (pour les 5 prochains jours)

*   **Endpoint:** `/weather/forecast`
*   **Méthode:** `GET`
*   **Paramètres de requête:**
    *   `city` (obligatoire) : Nom de la ville (e.g., `Berlin`, `Tokyo`).

**Exemple de requête:**

```bash
curl -X GET "http://localhost:8080/weather/forecast?city=Berlin"
```

**Exemple de réponse (JSON):**

```json
{
  "city": "Berlin",
  "forecast": [
    {
      "date": "2023-10-27T12:00:00Z",
      "temperature": 12.3,
      "feels_like": 10.0,
      "description": "pluie légère",
      "icon": "10d"
    },
    {
      "date": "2023-10-28T12:00:00Z",
      "temperature": 10.8,
      "feels_like": 9.1,
      "description": "ciel dégagé",
      "icon": "01d"
    }
    // ... autres prévisions ...
  ]
}
```

## 🏗️ Architecture

L'architecture de `Master-Weather-API-Golang` est conçue pour la modularité, la scalabilité et la maintenabilité, en s'inspirant des principes de la Clean Architecture.

```
+------------------+
|    API Client    |
| (e.g., cURL, App)|
+--------+---------+
         |
         v
+--------+---------------------------------------+
|          Master-Weather-API-Golang            |
|            (Go RESTful Service)               |
+-----------------------------------------------+
|                                               |
|  +---------------------+   +----------------+ |
|  |     HTTP Handlers   |---|  Business Logic| |
|  | (gin.Context, JSON) |   | (Services, Use | |
|  +----------+----------+   |   Cases)       | |
|             |              +-------+--------+ |
|             v                      |           |
|  +----------+----------+           v           |
|  |    Data Access /    |   +----------------+ |
|  |   Adapters (HTTP)   |<--| Domain Models  | |
|  | (OpenWeatherMap API)|   | (Entities)     | |
|  +---------------------+   +----------------+ |
|                                               |
+--------------------------+--------------------+
                           |
                           v
+--------------------------+--------------------+
| External Weather Provider (e.g., OpenWeatherMap)|
+-----------------------------------------------+
```

### Composants Principaux :

*   **HTTP Handlers (`pkg/api`) :** Couche d'entrée qui reçoit les requêtes HTTP, les valide, et délègue la logique métier aux services. Elle est responsable de la sérialisation/désérialisation JSON et de la gestion des réponses HTTP.
*   **Business Logic / Services (`pkg/service`) :** Contient la logique métier principale de l'application. Ces services orchestrent les opérations, manipulent les données des modèles de domaine et interagissent avec les adaptateurs pour les sources de données externes. C'est ici que sont appliquées les règles métier et la gestion de la concurrence via `goroutines` et `channels`.
*   **Data Access / Adapters (`pkg/adapter`) :** Cette couche est responsable de l'interaction avec les services externes (dans ce cas, l'API OpenWeatherMap). Elle abstrait les détails techniques de l'appel à l'API tierce, transformant les données externes en modèles de domaine internes.
*   **Domain Models (`pkg/model`) :** Définit les structures de données (entités) qui représentent le cœur de l'application, indépendantes de toute couche technique (API, base de données, etc.).
*   **Configuration (`pkg/config`) :** Gère le chargement sécurisé et la validation des variables d'environnement, telles que les clés API.

### Flux de Données Typique :

1.  Une requête HTTP arrive sur un **HTTP Handler**.
2.  Le Handler valide la requête et passe les paramètres au **Service** approprié.
3.  Le Service utilise un **Adapter** pour interroger le fournisseur de données externe (OpenWeatherMap).
4.  L'Adapter gère la communication avec l'API externe, convertit la réponse externe en **modèles de domaine** internes.
5.  Le Service reçoit les données des modèles de domaine, applique toute logique métier supplémentaire si nécessaire.
6.  Le Service retourne les données formatées au **HTTP Handler**.
7.  Le HTTP Handler renvoie la réponse JSON au client.

Cette architecture garantit une forte découplage, rendant l'application facile à tester, à maintenir et à faire évoluer. L'utilisation intensive de `goroutines` et `channels` dans les couches Service et Adapter permet de paralléliser les appels externes et d'optimiser les performances globales.

## 📸 Screenshots/Demos

Étant une API backend, les démonstrations visuelles sont principalement basées sur les réponses JSON. Vous pouvez utiliser des outils comme Postman, Insomnia, ou directement `curl` dans votre terminal pour interagir avec l'API et voir les résultats, comme illustré dans la section "Utilisation".

## 🤝 Contributions

Les contributions sont les bienvenues ! Si vous souhaitez améliorer ce projet, voici quelques étapes pour contribuer :

1.  **Fork** le dépôt.
2.  Créez une nouvelle **branche** pour votre fonctionnalité ou correction de bug (`git checkout -b feature/ma-super-feature` ou `fix/corrige-un-bug`).
3.  Effectuez vos modifications et assurez-vous que les tests passent.
4.  **Commitez** vos changements (`git commit -m 'feat: ajoute une nouvelle fonctionnalité'` ou `fix: corrige le problème X`).
5.  **Pushez** votre branche (`git push origin feature/ma-super-feature`).
6.  Ouvrez une **Pull Request** détaillée expliquant vos modifications.

Veuillez suivre les bonnes pratiques de codage Go et inclure des tests pour toute nouvelle fonctionnalité ou correction.

## 📄 Licence

Ce projet est sous licence [MIT License](https://opensource.org/licenses/MIT).

---