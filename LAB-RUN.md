# Run in the course OpenShift lab

GitHub Actions has been run. The OpenShift manifests are prepared but have not
been applied or tested in a cluster by this assistant.

The lab must provide `oc` login, your assigned project, a `pipeline` service
account with the course's build/deploy permissions, the `skills-network-learner`
storage class, and the git-clone, buildah, and openshift-client ClusterTasks.
This targets the v1beta1 API used in the supplied course instructions.

```bash
git clone https://github.com/00FY/ci-cd-final-project.git
cd ci-cd-final-project
bash bin/run-openshift.sh
```

If already cloned, enter that directory and use `git pull --ff-only` first.
The cleanup task clears the dedicated `oc-lab-pvc` pipeline workspace. Do not
use that claim for unrelated files. Only run after confirming the selected
project is your course lab. The script does not grant cluster permissions.

If preflight fails, report the exact output; cluster catalog/API changes need
to be checked against the live environment before adapting the manifests.

After success, save these actual console views:

- `oc-pipelines-console-pvc-details.png`: oc-lab-pvc, storage class and 1Gi.
- `oc-pipelines-oc-final.png`: all six pipeline steps.
- `oc-pipelines-oc-green.png`: the successful run with all six steps green.

Copy `evidence/oc-pipeline-app-logs.txt` for the application logs answer.
It must show the application startup banner and Gunicorn listening on 8000.
Do not submit manifest files, sample images, or local execution as run evidence.
