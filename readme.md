TODO:
* copy current world out of docker volume +
* back up data from current cluster +
* delete current cluster +
* create new cluster using az cli script
* upload world data to cluster
* create service as direct service for now
* create dns entry
* Set up backup somewhat like this: https://velero.io/blog/csi-integration/

mongoexport --uri mongodb://ninaapp:TPhZO5SF5ZSzPb3v7cpLla189iFT1FiSvgrlYNMbxnPrYOVbDkOSiGWuCTIoqtmjFpno16ZxQ3PGVYlUOQGfKA==@ninaapp.documents.azure.com:10255/?ssl=true&replicaSet=globaldb --collection=Attempts --out=/backup/attempts.json --db=NinaAppDev