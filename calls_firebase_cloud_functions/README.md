## in-app-calls-demo

Cloud functions needed for in-app calls demo application.

## Code Formatter

- Use Prettier as the Default Formatter
- Disable ESLint

## Deployment

To build Cloud Functions, the following have to be installed:

- [NodeJS 16](https://nodejs.org/)
- [Firebase CLI](https://firebase.google.com/docs/cli)

Follow these steps to prepare your functions and deploy:

- Switch your project to there you want to deploy cloud functions

```console
// $PROJECT_ID is a Firebase Project ID (like 'in-app-calls-demo')
firebase use $PROJECT_ID
```

- Install node modules

```shell
cd functions && npm install
```

- Run deploy script

```shell
cd functions && npm run deploy
```