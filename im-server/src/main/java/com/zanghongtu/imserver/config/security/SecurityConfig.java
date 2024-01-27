package com.zanghongtu.imserver.config.security;

import com.zanghongtu.imserver.service.ITokenService;
import com.zanghongtu.imserver.service.IUserInfoService;
import com.zanghongtu.imserver.service.IUserService;
import com.zanghongtu.imserver.service.impl.CustomUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
public class SecurityConfig {
    @Autowired
    private IUserService userService;
    @Autowired
    private ITokenService tokenService;

    @Autowired
    private IUserInfoService userInfoService;

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests((authz) -> authz
                        .requestMatchers("/swagger-ui.html").permitAll()
                        .requestMatchers("/v3/api-docs/**").permitAll()
                        .requestMatchers("/swagger-ui/**").permitAll()
                        .requestMatchers("/favicon.ico").permitAll()
                        .requestMatchers("/chatserver/**").permitAll()
                        .requestMatchers("/token/**").permitAll()
                        .requestMatchers("/register/**").permitAll()
                        .anyRequest().authenticated()
                )
                .httpBasic(httpBasicConfigurer -> httpBasicConfigurer
                        .authenticationEntryPoint(new CustomAuthenticationEntryPoint())
                        .authenticationDetailsSource(new CustomAuthenticationDetailsSource())
                )
                .csrf(AbstractHttpConfigurer::disable)
                .userDetailsService(userDetailsService)
        ;  // 使用自定义UserDetailsService
        http.addFilterAfter(new JwtAuthenticationFilter(tokenService, userService, userInfoService), UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }


    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

}