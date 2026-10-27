# CI/CD Tools and Practices Final Project Template

Project name: **ci-cd-final-project**

Application: Hit Counter Service.

This Flask REST API creates, reads, updates, lists, and deletes named hit counters.
The application runs with Gunicorn on port 8000.

## Continuous integration

GitHub Actions runs on pushes and pull requests to main:
1. Check out the repository.
2. Install the Python dependencies.
3. Lint the service with flake8.
4. Run the nine nose unit tests with coverage of the service package.

Workflow: `.github/workflows/workflow.yml`.

## Continuous delivery

Tekton task definitions in `.tekton/tasks.yml` include cleanup, nose, and flake8.
`.tekton/pipeline.yml` connects these to the lab-provided git-clone, buildah,
and openshift-client ClusterTasks. `.tekton/pvc.yml` requests 1Gi of storage.
See `LAB-RUN.md` for the lab commands.
The OpenShift pipeline uses cleanup, git-clone, flake8, nose, buildah, and deploy.
OpenShift execution evidence must come from the actual course lab.

## Run

```bash
python -m pip install -r requirements.txt
gunicorn service:app --bind 0.0.0.0:8000
```

## Validate

```bash
flake8 service --count --select=E9,F63,F7,F82 --show-source --statistics
flake8 service --count --max-complexity=10 --max-line-length=127 --statistics
nosetests -v --with-spec --spec-color --with-coverage --cover-package=service
```

## Attribution and license

Adapted from christian-schw/ci-cd-final-project and the IBM Skills Network
CI/CD final-project template. Original copyright notices and Apache-2.0
LICENSE are retained. This repository includes compatibility and CI fixes.
