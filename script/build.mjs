import { gql, Engine } from "@dagger.io/dagger";
new Engine().run(async (client) => {
    const result = await client
    .request(
        gql`
          {
            host {
              workdir {
                read {
                  dockerbuild(dockerfile: "Dockerfile") {
                    exec(input: {args: ["ls", "/app"]}) {
                      stdout
                    }
                  }
                }
              }
            }
          }
        `
      )
      .then((result) => result.host.workdir.read.dockerbuild);
});