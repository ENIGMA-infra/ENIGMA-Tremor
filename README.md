# Repository for the Enigma XYZ Working Group

An overview website of projects, progress, and documentation

## How to work with the website

To edit an existing page,
go into the `docs/` folder and edit the corresponding markdown file.
To add a new page,
add a new entry in the `nav` section of the `mkdocs.yml` file,
and then create a new markdown file in the `docs/` folder.

# First time setup 

## For editing the website locally

To locally build the site,
you need a python local environment:

The first time, do this:

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Then to build the website locally, run

```bash
mkdocs serve
```

and open your browser at the URL shown in the terminal.
Typically, it is `http://localhost:8000`.

## For publishing the website

At the top of your repo go to `Settings > Pages`. In the section "Build and deployment",
go to the "Branch" section, clikc the dropdown that says "None", and select the `gh-pages`
branch and then click the "Save" button.
You can learn more about this step at the [Github documentation](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site#publishing-from-a-branch).