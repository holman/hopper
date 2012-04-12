web: bundle exec unicorn --port $PORT

jobs:     bundle exec rake resque:work QUEUE=*

download: bundle exec rake resque:work QUEUE=download
index:    bundle exec rake resque:work QUEUE=index
probe:    bundle exec rake resque:work QUEUE=probe