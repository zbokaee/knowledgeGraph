echo "Usage: sh render.sh [publish]"
GUIDES=neo4j-guides


function render {
  $GUIDES/run.sh index.adoc index.html +1 "$@"
}


if [ "$1" == "publish" ]; then
  URL=guides.neo4j.com/nlp_knowledge_graphs
  render http://$URL -a env-training -a img=https://$URL/images
  s3cmd put --recursive -P *.html images s3://${URL}/
  s3cmd put -P index.html s3://${URL}
  echo "Publication Done"
else
  URL=localhost:8001
# copy the csv files to $NEO4J_HOME/import
  render http://$URL -a env-training -a img=http://$URL/images
  echo "Starting Websever at $URL Ctrl-c to stop"
  python $GUIDES/http-server.py
  # python -m SimpleHTTPServer
fi
