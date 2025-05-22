FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 8080
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["Freyr.FF.RI.NL.Subscription.Service/Freyr.FF.RI.NL.Subscription.Service.csproj", "Freyr.FF.RI.NL.Subscription.Service/"]
RUN dotnet restore "Freyr.FF.RI.NL.Subscription.Service/Freyr.FF.RI.NL.Subscription.Service.csproj"
COPY . .
WORKDIR "/src/Freyr.FF.RI.NL.Subscription.Service"
RUN dotnet build "Freyr.FF.RI.NL.Subscription.Service.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Freyr.FF.RI.NL.Subscription.Service.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Freyr.FF.RI.NL.Subscription.Service.dll"]
