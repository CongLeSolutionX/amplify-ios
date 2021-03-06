## Sync Based GraphQL

The following steps demonstrate how to set up an GraphQL endpoint with AppSync that is provisioned with conflict resolution (Sync-based API). The auth configured will be API key. The set up is used to run the tests in `GraphQLSyncBasedTests.swift`.

### Set-up

1. `amplify init`

2. `export AMPLIFY_DATASTORE_SYNC=true`

3. `amplify add api`

```perl
? Please select from one of the below mentioned services: `GraphQL`
? Provide API name: `<APIName>`
? Choose the default authorization type for the API `API key`
? Enter a description for the API key:
? After how many days from now the API key should expire (1-365): `365`
? Do you want to configure advanced settings for the GraphQL API `Yes, I want to make some additional changes.`
? Configure additional auth types? `No`
? Configure conflict detection? `Yes`
? Select the default resolution strategy `Auto Merge`
? Do you want to override default per model settings? `No`
? Do you have an annotated GraphQL schema? `Yes`
? Provide your schema file path: `schema.graphql`
```
When asked to provide the schema, create the `schema.graphql` file
```
type Post @model {
    id: ID!
    title: String!
    content: String!
    createdAt: AWSDateTime!
    updatedAt: AWSDateTime
    draft: Boolean
    rating: Float
    comments: [Comment] @connection(name: "PostComment")
}

type Comment @model {
    id: ID!
    content: String!
    createdAt: AWSDateTime!
    post: Post @connection(name: "PostComment")
}
```

4. `amplify push`
