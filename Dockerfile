# Use the official Microsoft ASP.NET image as a parent image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use the official Microsoft .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["dotnet/BeakPeekApi/BeakPeekApi.csproj", "dotnet/BeakPeekApi/"]
RUN dotnet restore "dotnet/BeakPeekApi/BeakPeekApi.csproj"
COPY . .
WORKDIR "/src/dotnet/BeakPeekApi"
RUN dotnet build "BeakPeekApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BeakPeekApi.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BeakPeekApi.dll"]
