# Kaiko Dev Tooling Assignment Solution

## Done
#### ML Ops Tasks:
- **Collect Logs and Results** - file name is `logs_results_htmlcov.zip`
- **Implement a Github Action workflow** - done in file - `.github/workflows/main.yml`
#### Dev Tooling Tasks:
- **CI/CD:** Implement CI/CD for the ML workloads using Github Actions:
      - **Linting:** Run linting on the codebase. - done in file - `.github/workflows/main.yml`
      - **Testing:** Run the tests and generate the coverage report. - done in file - `.github/workflows/main.yml`
## Not finished
- **CI/CD:** Implement CI/CD for the ML workloads using Github Actions:
  - **Artifact:** Create and publish below artifacts:
          - **Docker:** Build and Publish the docker images for [training](./madewithml/) and [serving](madewithml/serve.py)
          - **Models:** Bundle and upload the models as versioned artifacts to Github
 - **Local Dev Cluster:**
      Implement a local dev cluster.
 - **Pants Build System (Bonus):**
