# Use an official Flutter SDK image
FROM cirrusci/flutter:stable

# Set the working directory
WORKDIR /app

# Copy the current project to the working directory
COPY . .

# Get Flutter dependencies
RUN flutter pub get

# Build for web (example build target for Docker verification)
# This demonstrates a build process within Docker.
# For mobile builds, specific SDKs (Android/iOS) would be needed in the Docker image.
# RUN flutter build web --release

# For this lesson, we'll just run tests within Docker as a verification step.
CMD ["flutter", "test"]
