# Function for storing different docker run parameters for special use-cases.
# Also detects whether a container already is up or exists and uses attach 
# or start -a to connect to the container.
function dockerdev
  # Check if the container with name $argv exists/runs
  set running (docker inspect --format="{{ .State.Running }}" $argv)
  set existing (math "$status == 0")
  set mandatory_params --user="$USER"
  set mandatory_params --env="DISPLAY" $mandatory_params
  set mandatory_params --env="QT_X11_NO_MITSHM=1" $mandatory_params # otherwise qt will fail
  set mandatory_params --volume="/etc/group:/etc/group:ro" $mandatory_params
  set mandatory_params --volume="/etc/passwd:/etc/passwd:ro" $mandatory_params
  set mandatory_params --volume="/etc/shadow:/etc/shadow:ro" $mandatory_params
  set mandatory_params --volume="/etc/sudoers.d:/etc/sudoers.d:ro" $mandatory_params
  set mandatory_params --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" $mandatory_params

  # Set some use-case specific parameters
  switch $argv
    case "fzi"
      set specific_params --volume="/home/cakemix/devel/fzi/ic_workspace:/home/cakemix/ic_workspace:rw"
      set docker_image_name ros:fzi_devel
    case *
      set docker_image_name ros:graphical_with_user # default image
  end

  if [ $status = 0 ]
    if [ $running = true ]
      echo "Attaching to running container $argv"
      docker exec -it $argv /ros_entrypoint.sh /bin/bash
    else
      echo "Starting and attaching to existing container $argv"
      docker start -a $argv
    end
  else
    echo "Running new ros:devel container with name $argv"
    docker run -it $mandatory_params $specific_params --name $argv $docker_image_name
  end
end
