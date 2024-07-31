---
pcx_content_type: concept
title: Metrics and analytics
weight: 10
---

# Metrics and analytics

KV exposes analytics that allow you to inspect requests and storage across all namespaces in your account.

The metrics displayed in the [Cloudflare dashboard](https://dash.cloudflare.com/) charts are queried from Cloudflare’s [GraphQL Analytics API](/analytics/graphql-api/). You can access the metrics [programmatically](#query-via-the-graphql-api) via GraphQL or HTTP client.

## Metrics

KV currently exposes the below metrics:

| <div style="width:100px">Dataset  </div>    | <div style="width:235px">GraphQL Dataset Name </div>       | Description                                                   |
| ----------------------- | --------------------------- | ------------------------------------------------------------- |
| Operations              | `kvOperationsAdaptiveGroups`| This dataset consists of the operations made to your KV namespaces.  |
| Storage                 | `kvStorageAdaptiveGroups`   | This dataset consists of the storage details of your KV namespaces.   |

Metrics can be queried (and are retained) for the past 31 days.

## View metrics in the dashboard

Per-namespace analytics for KV are available in the Cloudflare dashboard. To view current and historical metrics for a database:

1. Log in to the [Cloudflare dashboard](https://dash.cloudflare.com) and select your account.
2. Go to [**Workers & Pages** > **KV**](https://dash.cloudflare.com/?to=/:account/workers/kv/namespaces).
3. Select an existing namespace.
4. Select the **Metrics** tab.

You can optionally select a time window to query. This defaults to the last 24 hours.

## Query via the GraphQL API

You can programmatically query analytics for your KV namespaces via the [GraphQL Analytics API](/analytics/graphql-api/). This API queries the same datasets as the Cloudflare dashboard, and supports GraphQL [introspection](/analytics/graphql-api/features/discovery/introspection/).

To get started using the [GraphQL Analytics API](/analytics/graphql-api/), follow the documentation to setup [Authentication for the GraphQL Analytics API](/analytics/graphql-api/getting-started/authentication/)

To use the GraphQL API to retrieve KV's datasets, you must provide the `accountTag` filter with your Cloudflare Account ID. The GraphQL datasets for KV include:

- `kvOperationsAdaptiveGroups`
- `kvStorageAdaptiveGroups`

### Examples

The following are common GraphQL queries that can be made to retrieve information about KV analytics. These queries make use of variables `$accountTag`, `$date_geq`, `$date_leq`, and `$namespaceId`, which should be set as GraphQL variables or replaced in line. These variables should look similar to these:

```json
{
    "accountTag":"<YOUR_ACCOUNT_ID>",
    "namespaceId": "<YOUR_KV_NAMESPACE_ID>",
    "date_geq": "2024-07-15",
    "date_leq": "2024-07-30"
}
```

#### Operations

To query the sum of read, write, delete, and list operations for a given `namespaceId` and for a given date range (`date_geq` and `date_leq`), grouped by `date` and `action:
```graphql
query {
    viewer {
        accounts(filter: { accountTag: $accountTag }) {
            kvOperationsAdaptiveGroups(
                filter: { namespaceId: $namespaceId, date_geq: $date_geq, date_leq: $date_leq }
                limit: 10000
				orderBy: [date_DESC]
            ) {
                sum {
                    requests
                }
                dimensions {
                    date
                    action
                }
            }
        }
    }
}
```


To query the distribution of the latency for read operations for a given `namespaceId` within a given date range (`date_geq`, `date_leq`):

```graphql
query {
    viewer {
        accounts(filter: { accountTag: $accountTag }) {
            kvOperationsAdaptiveGroups(
                filter: { namespaceId: $namespaceId, date_geq: $date_geq, date_leq: $date_leq, action: "GET" }
                limit: 10000
            ) {
                sum {
                    requests
                }
                dimensions {
                    action
                }
                quantiles {
                    latencyMsP25
                    latencyMsP50
                    latencyMsP75
                    latencyMsP90
                    latencyMsP99
                    latencyMsP999
                }
            }
        }
    }
}
```

To query your account-wide read, write, delete, and list operations across all KV namespaces:

```graphql
query {
    viewer {
        accounts(filter: { accountTag: $accountTag }) {
            kvOperationsAdaptiveGroups(filter: { date_geq: $date_geq, date_leq: $date_leq  }, limit: 10000) {
                sum {
                    requests
                }
                dimensions {
                    action
                }
            }
        }
    }
}
```

#### Storage

To query the storage details (`keyCount` and `byteCount`) of a KV namespace for every day of a given date range:

```graphql
query Viewer {
    viewer {
        accounts(filter: { accountTag: $accountTag }) {
            kvStorageAdaptiveGroups(
                filter: { date_geq: $date_geq, date_leq: $date_leq, namespaceId: $namespaceId }
                limit: 10000
                orderBy: [date_DESC]
            ) {
                max {
                    keyCount
                    byteCount
                }
                dimensions {
                    date
                }
            }
        }
    }
}
```