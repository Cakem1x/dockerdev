# Function to run new containers with some baked-in parameters for X.
# First parameter is the container's name,
# second parameter is the name of the image which should be used.
function dockerrun
  set mandatory_params --user="$USER"
  set mandatory_params --env="DISPLAY" $mandatory_params
  set mandatory_params --env="QT_X11_NO_MITSHM=1" $mandatory_params # otherwise qt will fail
  set mandatory_params --volume="/etc/group:/etc/group:ro" $mandatory_params
  set mandatory_params --volume="/etc/passwd:/etc/passwd:ro" $mandatory_params
  set mandatory_params --volume="/etc/shadow:/etc/shadow:ro" $mandatory_params
  set mandatory_params --volume="/etc/sudoers.d:/etc/sudoers.d:ro" $mandatory_params
  set mandatory_params --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" $mandatory_params

  docker run -it $mandatory_params --name $argv[1] $argv[2] # argv[1] should be the name, argv[2] should be the image
end
