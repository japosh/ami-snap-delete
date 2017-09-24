# ami-snap-delete
A simple shell script to full delete AMIs (deregister AMIs and delete associated snapshots).

## Usage
This script is really simple. You just have to execute in `bash` using command as follows:

``` bash delete_images.sh <parameter> ```

**Parameter** is used to search for AMIs. You can pass a full AMI name or pass just a part of it.

## Example

``` bash delete_images.sh image-example-* ```

This will search for any AMI who starts with **image-example-**.

The output of command is expected to be like this:

```
$ bash delete_images.sh image-example-*
Following are the images and snapshots found:

Images:
 image-example-1
 image-example-new
 
Snapshots:
 snap-047cd55d060c608db
 snap-03b90d9a520dfb94d 

Do you want to continue? [y/n]:
```

At this point, if you confirm the information about items to be deleted, answer `y` to proceed or `n` to abort operation. Typing `y` will return this:

```
Starting the Deregister of AMIs...   

image-example-1
image-example-new

Deleting the associated snapshots....   

snap-047cd55d060c608db
snap-03b90d9a520dfb94d



Images and snapshots successfully removed from your account!
