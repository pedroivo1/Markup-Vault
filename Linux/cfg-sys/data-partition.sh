# Transfer ownership of the mounted drive to the current user
sudo chown -R $USER:$USER /data

# Create the directory structure on the secondary drive
mkdir -p /data/Documents
mkdir -p /data/Downloads
mkdir -p /data/Music
mkdir -p /data/Pictures
mkdir -p /data/Videos

# Remove the original empty directories from the user's home folder
rmdir ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos 2>/dev/null

# Establish the definitive symbolic links
ln -sfn /data/Documents ~/Documents
ln -sfn /data/Downloads ~/Downloads
ln -sfn /data/Music ~/Music
ln -sfn /data/Pictures ~/Pictures
ln -sfn /data/Videos ~/Videos
