# Deploy and Host Sourcebot on Railway

Sourcebot is a self-hosted code search and navigation tool. It indexes repositories from GitHub, GitLab, Bitbucket, Gitea and plain Git with Zoekt, then offers fast regex and symbol search, cross-repository navigation, a code browser, an API and an MCP server so AI agents can search your codebase.

## About Hosting Sourcebot

This template deploys Sourcebot v5.1.14 from a public wrapper repository, with Railway Postgres, Railway Redis and a volume for clones and search indexes. On first start the wrapper signs in once with the configured admin credentials, which makes that account the owner before anyone else can. Later sign-ups need owner approval. Set `SOURCEBOT_REPOS` to a list of GitHub repositories to index, and add a `GITHUB_TOKEN` for private ones, or configure connections in the UI. Indexing uses memory, so plan for at least 2 GB with larger repositories. Search results link straight into the built-in code browser.

## Common Use Cases

- Searching code across many repositories in one place
- Giving AI coding agents code search over MCP
- Onboarding engineers onto large or unfamiliar codebases

## Dependencies for Sourcebot Hosting

- `aalfath/sourcebot-railway-template` (wrapper around `ghcr.io/sourcebot-dev/sourcebot:v5.1.14`)
- Railway Postgres (`ghcr.io/railwayapp-templates/postgres-ssl:18`) with a volume
- Railway Redis with a volume
- A Railway volume at `/data`

### Deployment Dependencies

- [Sourcebot documentation](https://docs.sourcebot.dev/)
- [Sourcebot v5.1.14 release](https://github.com/sourcebot-dev/sourcebot/releases/tag/v5.1.14)
- [Wrapper repository](https://github.com/aalfath/sourcebot-railway-template)
- [Railway private networking](https://docs.railway.com/reference/private-networking)

### Implementation Details

| Service | Source | Networking | Storage |
| --- | --- | --- | --- |
| sourcebot | `aalfath/sourcebot-railway-template` | public domain on 3000 | volume at `/data` |
| Postgres | Railway Postgres 18 | private only | volume |
| Redis | Railway Redis | private only | volume |

```env
SOURCEBOT_REPOS=your-org/api,your-org/web
GITHUB_TOKEN=ghp_...   # only for private repositories
```

| Variable | Default | Purpose |
| --- | --- | --- |
| `SOURCEBOT_ADMIN_EMAIL` / `SOURCEBOT_ADMIN_PASSWORD` | `admin@example.com` / generated | Owner account, claimed on first start |
| `SOURCEBOT_REPOS` | `railwayapp/cli` | GitHub repositories to index |
| `AUTH_SECRET` / `SOURCEBOT_ENCRYPTION_KEY` | generated | Session signing and secret encryption |
| `REDIS_URL` | Redis reference with `?family=0` | Queue; the suffix enables IPv6 lookups |

Notes:

- Setting `CONFIG_PATH` to your own declarative config file takes precedence over `SOURCEBOT_REPOS`.
- The web UI and API need a signed-in user; create API keys in settings for scripts and MCP clients.

This is a community-maintained deployment package and does not imply affiliation with or endorsement by the Sourcebot project or its maintainers.

## Why Deploy Sourcebot on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Sourcebot on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
