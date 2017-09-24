# Remotion of AMI and Snapshot
When you deregister a AMI in your AWS account, snapshots attached on this AMI are not deleted together, you have to delete them separately, making this proccess slow and annoying.
In most of times, you want to completely remove AMI from your account. for this, i developed this shell script to make things easier and faster to do.

## Usage
It's really simple, you just have to execute script with `bash` command, as showing below:

``` bash delete_images.sh <Parameter> ```

**Parameter** is used to search the AMIs. You can pass a full AMI name or pass just a part.

## Example

``` bash delete_images.sh image-example-* ```

This will search for any AMI name who starts with **image-example-**.

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

At this point, you have to confirm the information about items to be deleted. Answer `y` to proceed or `n` to abort operation.
Typing `y` will return this:

```
Starting the Deregister of AMIs...   

image-example-1
image-example-new

Deleting the associated snapshots....   

snap-047cd55d060c608db
snap-03b90d9a520dfb94d


Images and snapshots successfully removed from your account!
```

And you are done! The AMIs are deregistered and their respective snapshots deleted from your account!
