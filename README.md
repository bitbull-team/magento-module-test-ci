Test locally with:

```
docker run -it --rm -v `pwd`:/opt/pipeline-build -e "MODULE_DIR=/opt/pipeline-build" -w /opt/pipeline-build -p 80 bitbull/webserver-dev bash
```