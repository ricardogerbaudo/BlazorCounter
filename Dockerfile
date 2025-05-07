# =========================
# STAGE 1: Base (Shared setup)
# =========================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS base
WORKDIR /src
# Add any global setup, like NuGet config, tools, or proxy config here
COPY *.sln ./

# =========================
# STAGE 2: Build
# =========================
FROM base AS build
ARG BUILD_CONFIGURATION=Release
COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c $BUILD_CONFIGURATION -o /app/out

# =========================
# STAGE 3: Final (Runtime)
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app

COPY --from=build /app/out ./

EXPOSE 8080
EXPOSE 8081
ENTRYPOINT ["dotnet", "BlazorCounter.dll"]
