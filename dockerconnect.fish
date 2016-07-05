# Function for storing different docker run parameters for special use-cases.
# Also detects whether a container already is up or exists and uses attach 
# or start -a to connect to the container.
function dockerconnect
  # Check if the container with name $argv exists/runs
  set running (docker inspect --format="{{ .State.Running }}" $argv[1])

  if [ $running = true ]
    echo "Container $argv[1] already running. Exec-ing a new bash."
    docker exec -it $argv[1] /ros_entrypoint.sh /bin/bash
  else
    echo "Container $argv[1] is not running. Starting and attaching to it."
    docker start $argv[1]
    docker attach $argv[1]
  end

end
