# Our Docs

Serve documentation (static when site) behind a GitHub authentication. 

## Why

Netlify, Vercel, GitHub Pages or awesome to serve and build static when site.
But there is no easy way to restrict access. Our Docs restriction is basic, if you can
access to GitHub repository, you can access the website.

## How it works

### Adding documentation to Our Docs

1. Install the GitHub app `Our Docs` to a repository.
2. Go to <<to be determined>> and Login to your GitHub account.
3. Select **Add Docs**
4. Select the repo and specify a branch where your static documentation will be.
5. Click to **Go to Our Docs**

### Building your documentation

Our Docs was thinking to let you handle the techno to build and generate your documentation. Our Docs will received
webhooks when the specified branch received new commit.

#### Example

* Create a new project with [Jekyll](https://jekyllrb.com/)
* Push it to GitHub
* Setup an GitHub action to build your static website. [Details](https://jekyllrb.com/docs/continuous-integration/github-actions/).
* Configure the action to push on the branch choose in Our Docs.


## Development

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
