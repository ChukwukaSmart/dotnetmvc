# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project files to the container
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application files
COPY . .

# Build the application
RUN dotnet publish -c Release -o out

# Use the runtime image for the final build
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime

# Set the working directory in the runtime container
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app/out .

# Expose the port your application listens on (default for Kestrel is 5000)
EXPOSE 8082

# Start the application
ENTRYPOINT ["dotnet", "oforapps.dll"]
