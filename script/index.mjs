import { gql, Engine } from "@dagger.io/dagger";
new Engine().run(async (client) => {
    const result = await client
    .request(
        gql`
          {
            host {
              workdir {
                read {
                  rails(runArgs: ["routes"]) {
                    id
                  }
                }
              }
            }
          }
        `
      )
      .then((result) => result.host.workdir.read.rails);
});