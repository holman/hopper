web: bundle exec unicorn --port $PORT

jobs:     bundle exec rake resque:work QUEUE=*

download: bundle exec rake resque:workers QUEUE=download COUNT=1
index:    bundle exec rake resque:workers QUEUE=index    COUNT=1
probe:    bundle exec rake resque:workers QUEUE=probe    COUNT=2