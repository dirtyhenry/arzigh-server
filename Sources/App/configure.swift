import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a PostgreSQL database
    
    let postgres = PostgreSQLDatabase(config: PostgreSQLDatabaseConfig(
        hostname: Environment.get("POSTGRESQL_HOSTNAME")!,
        port: Int(Environment.get("POSTGRESQL_PORT")!)!,
        username: Environment.get("POSTGRESQL_USERNAME")!,
        database: Environment.get("POSTGRESQL_DATABASE")!,
        password: Environment.get("POSTGRESQL_PASSWORD")!,
        transport: (env.isRelease ? .modernTLS : .cleartext)
    ))

    // Register the configured PostgreSQL database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: postgres, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .psql)
    services.register(migrations)
}
