import { gql, Engine } from "@dagger.io/dagger";
const config = {
  LocalDirs: {
    tfconfig: "terraform"
  }
}
new Engine(config).run(async (client) => {
  if (!process.env.TF_TOKEN) {
    console.log(
      "Missing terraform cloud token. Please set it to the env variable $TF_TOKEN"
    );
    process.exit(1);
  }
  const tokenCleartext = process.env.TF_TOKEN
  const terraformDir = "tfconfig"

  const token = await client
  .request(
    gql`
      query ($tokenCleartext: String!) {
        core {
          addSecret(plaintext: $tokenCleartext)
        }
      }
    `,
    {
      tokenCleartext
    }
  )
  .then((result) => result.core.addSecret)

  const dir = await client
  .request(
    gql`
      query ($terraformDir: String!) {
        host {
          dir(id: $terraformDir) {
            read {
              id
            }
          }
        }
      }
    `,
    {
      terraformDir
    }
  )
  .then((result) => result.host.dir.read.id);

  const plan = await client
  .request(
    gql`
      query (
        $dir: FSID!
        $token: SecretID!
      ){
        terraform {
          apply(
            config: $dir
            token: $token
          ) {
            id
          }
        }
      }
    `,
    {
      dir,
      token
    }
  )
  .then((result) => result.terraform.destroy);
});