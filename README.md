Couple of caveats:
- Please make sure to first chmod helper.sh to executable, run it and choose "config".
- In the parameters section of base-stack.yaml there's a reference to a ssm parameter. Add this parameter to AWS SSM before     running this template or it will fail. I've added this because Github kept on automatically revoking my OAuth key after       pushing the templates to the repository. You can slash it out and replace it with a valid OAuthToken. 

