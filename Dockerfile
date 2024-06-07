# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["dotnet/BeakPeekApi/BeakPeekApi.csproj", "dotnet/BeakPeekApi/"]
RUN dotnet restore "dotnet/BeakPeekApi/BeakPeekApi.csproj"
COPY . .
WORKDIR "/src/dotnet/BeakPeekApi"
RUN dotnet build "BeakPeekApi.csproj" -c Release -o /app/build

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS development
COPY ./dotnet/BeakPeekApi/ /source
WORKDIR /source
EXPOSE 8080
CMD dotnet run --no-launch-profile

FROM build AS publish
RUN dotnet publish "BeakPeekApi.csproj" -c Release -o /app/publish

# Use the official .NET runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 8080
ENTRYPOINT ["dotnet", "watch" "BeakPeekApi.dll"]
