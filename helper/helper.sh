#!/bin/bash
clear
. helper.conf 
echo " "
cat sentia.txt
echo " "
echo "Today we're working on the" "$stack" "Stack."
echo "The bucket we're getting our templates from and to is:" "$bucket"
echo "This is our parent-stack:" "$template"  
echo "--------------------------------------------------------------------------------------------"
echo " "
echo "Actions: (1)create, (2)sync-all, (3)sync-s3, (4)delete, (5)git, (6)config or (q)quit." 
echo " " 
read wish

if [ "$wish" == "create" ] || [ "$wish" == 1 ] ; then
        echo "As you wish, we shall create this new stack called" "$stack"
        aws cloudformation create-stack --stack-name "$stack" --template-url "$template" --capabilities CAPABILITY_NAMED_IAM 
        sleep 10
        clear
        ./helper.sh 
        exit 1
elif [ "$wish" == "sync-all" ] || [ "$wish" == 2 ] ; then
        echo " "
        aws s3 sync ../ "$bucket" --exclude '*' --include '*.yaml' 
        aws cloudformation update-stack --stack-name $stack --template-url $template 
        echo "We shall bring the news to every corner and s3 bucket."
        sleep 5
        clear
        ./helper.sh 
        exit 1
elif [ "$wish" == "sync-s3" ] || [ "$wish" == 3 ] ; then
        echo " "
        aws s3 sync ../ "$bucket" --exclude '*' --include '*.yaml' 
        echo "We shall bring the news to every s3 bucket. Just s3. S3."
        sleep 5
        clear
        ./helper.sh 
        exit 1
elif [ "$wish" == "delete" ] || [ "$wish" == 4 ] ; then
        echo "We shall destroy what you have created. After your confirmation."
        echo " "
        echo "We don't take prisoners. Sure about this? Yes or no..."
        read confirmation
          if [ "$confirmation" == "yes" ] ; then 
            aws cloudformation delete-stack --stack-name "$stack"
            sleep 5
            clear
            ./helper.sh  
            exit 1
          else
            echo "Cancelling and taking you back to the menu"
            sleep 2
            clear
            ./helper.sh  
            exit 1
          fi 
elif [ "$wish" == "git" ] || [ "$wish" == 5 ] ; then
        echo "We shall bring light to all git repositories. What do you want to say in your commit?" 
        read commit 
        cd ..
        git add *
        git commit -m "$commit"
        git push origin master
        echo "Done. Commit message is:" $commit 
        sleep 5
        cd helper 
        clear
        ./helper.sh  
        exit 1
elif [ "$wish" == "config" ] || [ "$wish" == 6 ] ; then
        echo "Current S3 bucket is:" "$bucket" ". What's the new bucket? I shall not create one for you!" 
        read newbucket
        echo "Current stack is:" "$stack" ". What's the new name? Please adhere to cfn naming conventions or this will break."
        read newstack
        echo "Current parent-stack is:" "$template" ". What's the new template? Has to be a valid http address." 
        read newtemplate
        echo "Are you sure you want to change this configuration? Yes or no."
        read confirm
          if [ "$confirm" == "yes" ] || [ "$confirm" == "y" ] ; then 
            rm helper.conf 2> /dev/null 
            echo "stack=""$newstack" > helper.conf 
            echo "bucket=""$newbucket" >> helper.conf 
            echo "template=""$newtemplate" >> helper.conf 
            sleep 5
            clear
            ./helper.sh  
            exit 1
          else
            echo "Cancelling and taking you back to the menu"
            sleep 2
            clear
            ./helper.sh  
            exit 1
          fi 
        ./helper.sh
        exit 1
elif [ "$wish" == "quit" ] || [ "$wish" == "q" ] ; then
        echo "Goodbye.."  
        exit 1
else
        echo "Please adhere to my command. I am giving you a second chance"
        sleep 2
        clear
        ./helper.sh
fi





