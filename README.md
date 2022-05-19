<img src="https://github.com/dbmi-bgm/cgap-pipeline/blob/master/docs/images/cgap_logo.png" width="200" align="right">

# CGAP Pipeline Main

This is the main repository for the cgap bioinformatics pipeline.

## Documentation

Documentation for all CGAP Pipelines can now be found here:
https://cgap-pipeline-main.readthedocs.io/en/latest/

## Initialize the Repository

Clone the repository.

    # Clone the repository
    # The submodules will be empty and set to the current commit

    git clone https://github.com/dbmi-bgm/cgap-pipeline-main.git

    # Check out the desired version
    # This will set the submodules to the commit saved for that version

    git checkout <version>

Populate the submodules.

    # Download the content for each submodule
    # The submodules will be set in detached state on their current commit

    make pull

Install the repository.

    make configure
    make update
    make build

See `make info` for more info on make targets.

## Deploy the Pipeline

To automatically deploy all the pipeline components in target environment:

  - Set credentials to authenticate to target environment. A minimal set of credentials is required and can be defined in `.env` file. Additional credentials can be required to authenticate to the target environment, see [*here*](https://cgap-pipeline-utils.readthedocs.io/en/latest/deploy_pipelines.html) for more details.
  - Run commad:

        make deploy-all
