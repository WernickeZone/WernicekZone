Documentation du deploiment de WernickeZone

---Docker---
!!! Il faut que le user soit dans le groupe docker !!!
docker ps -a: voire les images créers
docker run -i -t id: invite de commande dans l'image id
docker run -d -p 80:80 id: execute l'image id en mode démon en liant les ports 80
docker kill id: etaint une machine
docker build --no-cache=true . :construit une image a partir d'un Dockerfile sans utiliser le cache
docker rmi id: supprime d'image
docker images: list les images
docker rm $(docker ps -a -q): delete all images
docker build -t production --no-cache=true . : créer une image production
docker run -d -p 3000:3000 --name 'wernickeZone' production sh exec.sh : lance l'image production avec le nom wernickeZone
docker restart wernickeZone : redemarre le docker wernickeZone. Si l'image est modifié, les modifs sont prises en compte
docker images --no-trunc| grep none | awk '{print $3}' | xargs -r docker rmi : vide le cache docker
