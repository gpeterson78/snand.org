# snand.org authgen
### .env File Configuration

1. **Locate the Setup Script**: Within the root directory of this project, you will find a script named `genenv.sh`. This script will configure the necessary `.env` file.

2. **Execute the Script**: Navigate to your project's root directory in your terminal and run the following command:

    ```bash
    sudo chmod +x genenv.sh
    ./genenv.sh
    ```

   Follow the instructions provided by the script carefully. It will prompt you to enter various configuration details necessary for the proper functioning of the Authentik provider.

3. **Verify Configuration**: After completing the script, open the `.env` file to verify that all your settings are correct. Modify any values directly in the file if necessary.  It should look similar to:

    ```shell
PG_PASS=j2ZGhQEYcVuAnbf4y0z0+S5gLMguutvPRMx6U0vjU0Pgnu/9
AUTHENTIK_SECRET_KEY=utqrSGoeY1Mc/1ZguRL+sDXnoxgAdZG9YtFXL2c+2ExM2PZzso3Z6bnu5h/zlELA
AUTHENTIK_EMAIL__HOST=smtp.gmail.com
AUTHENTIK_EMAIL__PORT=587
AUTHENTIK_EMAIL__USERNAME=USERNAME
AUTHENTIK_EMAIL__PASSWORD="PASSWORD"
AUTHENTIK_EMAIL__USE_TLS=true
AUTHENTIK_EMAIL__USE_SSL=false
AUTHENTIK_EMAIL__TIMEOUT=10
AUTHENTIK_EMAIL__FROM=admin@snand.org
    ```
## Additional Information

For detailed information about Authentik and its configuration options, refer to the official documentation:

- [Authentik Documentation](https://goauthentik.io/docs)


