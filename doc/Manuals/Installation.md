# Technical Installation Manual

## Introduction

BeakPeek was developed with a backend and frontend and will there fore have two
seperate sub sections for installation for the frontend and backend installation

## Prerequisites

### Frontend

- Flutter SDK
- Android SDK Platform, API 35.0.1
- Android SDK Command-line Tools
- Android SDK Build-Tools
- Android SDK Platform-Tools
- Android Emulator

The full guide on how to install of of these can be found at the URL:
<https://docs.flutter.dev/get-started/install>

- Select the operating system you are using
- Select android

### Backend

- .Net SDK 8.0
- ASP.Net Core Runtime 8.0
- .Net Runtime 8.0
- Docker Desktop 4.42 >=

The full guide on how to install all of the .Net dependencies can be found at
the URL:
<https://learn.microsoft.com/en-us/dotnet/core/install/>

- Then select the operating system you are using from the choices available

The full guide on how to install docker desktop can be found at the URL:
<https://docs.docker.com/desktop/>

- Then select the operating system you are using from the choices available

## Installation

To start with installing BeakPeek for local development first clone the
repository onto your local machine.

```bash
git clone https://github.com/COS301-SE-2024/BeakPeek
```

Then open the directory/folder that you cloned the repository into either with a
file explorer or preferably with the command line of your operating system

### Frontend Installation

If you are only interested in using/working on the frontend of BeakPeek then you
can clone only the frontend directory of BeakPeek by running these commmands:

```bash
git clone -n --depth=1 --filter=tree:0 \
    https://github.com/COS301-SE-2024/BeakPeek
cd BeakPeek
git sparse-checkout set --no-cone beakpeek
git checkout
```

### Backend Installation

If you are only interested in using/working on the backend of BeakPeek then you
can clone only the frontend directory of BeakPeek by running the following to
clone the entire backend which includes the test

```bash
git clone -n --depth=1 --filter=tree:0 \
    https://github.com/COS301-SE-2024/BeakPeek
cd BeakPeek
git sparse-checkout set --no-cone dotnet
git checkout
```

Or if you only want the Main Api:

```bash
git clone -n --depth=1 --filter=tree:0 \
    https://github.com/COS301-SE-2024/BeakPeek
cd BeakPeek
git sparse-checkout set --no-cone dotnet/BeakPeekApi
git checkout
```

## Running the code

### Running the Frontend

You will have to add a single file filled with your own details for connecting
to your own login provider, BeakPeek uses Azure so the following is used for the
Azure Config which just needs to be added to the lib directory in the beakpeek
directory. The file should be called azure_config.dart

```dart
String domain = 'com.example.beakpeek';
String clientID = '<clientID>';
String issuer =
    'https://<Issuer Url>';
String bundlerID = 'com.example.beakpeek';
String redirectURL = 'com.example.beakpeek://login-callback';
String discoveryURL =
    'https://<Url that the signing can be discovered on>';
String scope = 'https://beakpeak.onmicrosoft.com/com.example.beakpeek/callback';

String initialUrl = '<Initial Url>';
String tokenUrl =
    '<Url path that the token is retrieved from>';

String accessToken = '';
bool loggedIN = false;
```

To run the frontend you will have to make sure that there is an android phone
installed on the android emulator and that all of the dependencies are
installed.

To ensure that all of the flutter dependencies are installed run the following
in the './beakpeek' directory using the command line:

```bash
flutter pub get
```

To verify that you have a running emulator for running the fronend run the
following command:

```bash
flutter devices
```

To run the app run the following command

```bash
flutter run
```

### Running the Backend

You will have to add a single file to the './dotnet/BeakPeekApi' directory as
usually it contains api keys, to add it you can make a new file with the
following contents in it giving your own flickr api key where necessary

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "FLICKR_API_KEY": "<Your Flickr Api Key"
}
```

To run the backend there are two methods one being using docker to host the api
and to host the database and the other is running it locally using your own
database.

#### Using Docker

To run the api locally using docker is really simple. First ensure that docker
and docker-compose are installed and then run the following command from the

```bash
docker compose up --build
```

The api will now be accessable from 'localhost:5000' and then to view the
swagger documents of the api go to the following link 'localhost:5000/swagger/index.html'

#### Using Your own database

To run the api locally using your own database you will first need to find the
databases connection string which can be found in various methods depending on
the database you are using and how it is hosted on your machine or over the
internet.

Next to connect to your database you will have to change the value of the 'DefaultConnection'
the key value pair found in the appsettings.development.json file, to the
connection string of your database.

next to run the api you will have to use the command line in the './dotent/BeakPeekApi'
and run the following command:

```bash
dotnet run
```

This will run the dotnet api locally where it will be accessable on the 'localhost:5050'
url and the swagger api documentation can be found at 'localhost:5050/swagger/index.html'

### Running tests

#### Frontend Tests

To run the tests for the flutter frontend open the command prompt in the the
'./beakpeek' directory and run the following command:

```bash
flutter test --coverage
```

#### Backend Tests

To run the tests for dotnet backend open the command prompt in the './dotnet'
directory and run the following command:

```bash
dotnet test
```

## Extra notes

The database that is created when using the docker method for running the
backend uses only 500 entries from each province for the data as the database
has approximately 1.4M entries on it and is very difficult to run locally.

To import the full data set to your own database use the endpoints that have
been provided by the api at the urls for importing that can be found on the
swagger documentation when running the api in development.
