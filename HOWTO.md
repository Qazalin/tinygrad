grab token: https://pypi.org/manage/account/token/?selected_project=tinygrad-tools
update version, rm -rd dist
python3 -m build
twine upload dist/*
