const express = require('express');
const { graphqlHTTP } = require('express-graphql');
const { buildSchema } = require('graphql');
const exec = require('child_process').exec;
const execSync = require('child_process').execSync;

const githubToken = process.env.GH_PAT;
if (githubToken) {
    execSync(`echo ${githubToken} | gh auth login --with-token`);
}

const schema = buildSchema(`
    type Mutation {
        createIssue(title: String!, body: String!): String
    }
`);

const root = {
    createIssue: ({ title, body }) => {
        return new Promise((resolve, reject) => {
            const command = `gh issue create -R [Your-Repo-Name] -t "${title}" -b "${body}"`;
            exec(command, (error, stdout, stderr) => {
                if (error) {
                    reject(`exec error: ${error}`);
                } else {
                    resolve(stdout);
                }
            });
        });
    }
};

const app = express();

app.use('/graphql', graphqlHTTP({
    schema: schema,
    rootValue: root,
    graphiql: true,
}));

const port = process.env.CONTAINER_PORT;
app.listen(port, () => {
    console.log(`Running a GraphQL API server at http://localhost:${port}/graphql`);
});

