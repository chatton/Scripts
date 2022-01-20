#!/bin/bash


# Remove finalizers from resources of a specified type matching a namespace filter.

FILTER="${1}"
TYPE="${2}"

namespaces="$(kubectl get namespaces -o name | grep ${FILTER})"
for n in ${namespaces}; do
  namespace_name="$(echo ${n} | cut -d/ -f2)"
  project_name="$(kubectl get ${TYPE} -n ${namespace_name} -o name | cut -d/ -f2)"
  kubectl patch "${TYPE}/${project_name}" -n "${namespace_name}" -p '{"metadata":{"finalizers":[]}}' --type=merge
done

