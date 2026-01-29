plugins {
	java
	id("org.springframework.boot") version "3.4.3"
	id("io.spring.dependency-management") version "1.1.7"
}

group = "com.example"
version = "0.0.1-SNAPSHOT"

java {
	toolchain {
		languageVersion = JavaLanguageVersion.of(21)
	}
}

repositories {
	mavenCentral()
}

dependencies {
	// --- ОСНОВНЫЕ СТАРТЕРЫ SPRING BOOT ---
	implementation("org.springframework.boot:spring-boot-starter-web")
	implementation("org.springframework.boot:spring-boot-starter-security")
	implementation("org.springframework.boot:spring-boot-starter-websocket")
	implementation("org.springframework.boot:spring-boot-starter-freemarker")
	implementation("org.springframework.boot:spring-boot-starter-data-jpa")
	implementation("org.springframework.boot:spring-boot-starter-validation")

	// --- БЕЗОПАСНОСТЬ MESSAGING (СПЕЦИФИЧНО ДЛЯ WEB SOCKETS) ---
	implementation("org.springframework.security:spring-security-messaging")

	// --- ДРУГИЕ ЗАВИСИМОСТИ ---
	implementation("org.thymeleaf:thymeleaf-spring6:3.1.2.RELEASE")
	compileOnly("org.projectlombok:lombok:1.18.36")
	annotationProcessor("org.projectlombok:lombok:1.18.36")
	runtimeOnly("org.postgresql:postgresql")

	// --- JWT ЗАВИСИМОСТИ ---
	implementation("io.jsonwebtoken:jjwt-api:0.12.5")
	runtimeOnly("io.jsonwebtoken:jjwt-impl:0.12.5")
	runtimeOnly("io.jsonwebtoken:jjwt-jackson:0.12.5")

	// --- WebJars для клиентских библиотек SockJS и STOMP.js ---
	implementation ("org.webjars:webjars-locator-core")
	implementation ("org.webjars:sockjs-client:1.5.1")
	implementation ("org.webjars:stomp-websocket:2.3.4")
}

tasks.withType<Test> {
	useJUnitPlatform()
}