# Function for storing different docker run parameters for special use-cases.
# Also detects whether a container already is up or exists and uses attach 
# or start -a to connect to the container.
function dockerconnect
  # Check if the container with name $argv exists/runs
  set running (docker inspect --format="{{ .State.Running }}" $argv)

  if [ $running = true ]
    echo "Container already running. exec-ing a new /bin/bash in it."
    docker exec -it $argv[1] /ros_entrypoint.sh /bin/bash
  else
    echo "Container is not running. Starting and attaching to it."
    docker start -a $argv[1]
  end

end
