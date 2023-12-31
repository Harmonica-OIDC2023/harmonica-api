source .env

func create -l python $FUNCTION_NAME
python3 migration.py

mv ./func.py $FUNCTION_NAME/func.py
mv ./requirements.txt $FUNCTION_NAME/requirements.txt

kubectl create secret docker-registry container-registry \
  --docker-server=https://iad.ocir.io/ \
  --docker-email=$USER_EMAIL \
  --docker-username=$TENANCY_NAMESPACE/$USER_EMAIL \
  --docker-password=$USER_PASSWORD

kubectl patch serviceaccount default -p "{\"imagePullSecrets\": [{\"name\": \"container-registry\"}]}"

func deploy -p /app/knative_to_oci/$FUNCTION_NAME -r iad.ocir.io/$TENANCY_NAMESPACE