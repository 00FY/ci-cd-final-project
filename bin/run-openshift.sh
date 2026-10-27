#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
command -v oc >/dev/null
oc whoami >/dev/null
namespace=$(oc project -q)
[ -n "$namespace" ] || { echo "Select your course lab project first."; exit 1; }
# These ClusterTasks and the pipeline service account are supplied by the course lab.
# Fail before modifying resources if the prerequisites are absent.
oc get clustertask git-clone buildah openshift-client >/dev/null
oc get storageclass skills-network-learner >/dev/null
oc get serviceaccount pipeline >/dev/null
if oc get pvc oc-lab-pvc >/dev/null 2>&1; then
  echo "Using existing oc-lab-pvc. Its workspace contents are cleared by cleanup."
fi
oc apply -f .tekton/tasks.yml
oc apply -f .tekton/pvc.yml
oc apply -f .tekton/pipeline.yml
run=$(oc create -f - -o jsonpath='{.metadata.name}' <<EOF
apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
  generateName: ci-cd-final-project-
spec:
  serviceAccountName: pipeline
  pipelineRef:
    name: ci-cd-final-project
  params:
    - name: build-image
      value: image-registry.openshift-image-registry.svc:5000/${namespace}/ci-cd-final-project:latest
  workspaces:
    - name: output
      persistentVolumeClaim:
        claimName: oc-lab-pvc
EOF
)
echo "Started PipelineRun: $run"
echo "View it in the OpenShift console or run: tkn pipelinerun logs $run -f"
oc wait --for=condition=Succeeded "pipelinerun/$run" --timeout=900s
mkdir -p evidence
oc logs deployment/ci-cd-final-project --tail=200 | tee evidence/oc-pipeline-app-logs.txt
oc get pvc oc-lab-pvc -o yaml > evidence/pvc-details.yml
oc get "pipelinerun/$run" -o yaml > evidence/pipeline-run.yml
echo "Capture the PVC, pipeline definition, and successful PipelineRun in the OpenShift console."
