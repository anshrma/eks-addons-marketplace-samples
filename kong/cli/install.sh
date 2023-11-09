aws eks create-addon --cluster-name kubecon2023 --addon-name kong_konnect-ri \
    --addon-version v3.4.1-eksbuild.1 \
    --resolve-conflicts Overwrite \
    --configuration-values file://kong_konnect-ri.yaml \
    --region ap-northeast-2
