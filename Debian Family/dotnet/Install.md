# Install .NET

## Add the Official .NET Repository

```sh
# Add the official .NET repository
sudo add-apt-repository ppa:dotnet/backports

# Update your system's package list
sudo apt-get update

# Install the .NET SDK
sudo apt-get install -y dotnet-sdk-10.0

# Verify the installation
dotnet --list-sdks
```

## Create and Run App

```sh
# Generate a new console app
dotnet new console -o HelloDotNet

# Navigate into the project folder
cd HelloDotNet

# Run the application
dotnet run
```

Success: If your terminal prints Hello, World!, congratulations! You have successfully installed .NET from zero and compiled your very first program.
