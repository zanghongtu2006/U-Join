package com.zanghongtu.imserver.config.security;

import com.zanghongtu.imserver.config.Constants;
import com.zanghongtu.imserver.model.UserInfo;
import com.zanghongtu.imserver.service.ITokenService;
import com.zanghongtu.imserver.service.IUserInfoService;
import com.zanghongtu.imserver.service.IUserService;
import com.zanghongtu.imserver.threadlocal.ReqInfo;
import com.zanghongtu.imserver.threadlocal.ReqInfoOperator;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Map;
import java.util.Optional;

public class JwtAuthenticationFilter extends OncePerRequestFilter {
    private ITokenService tokenService; // 你的TokenService

    private IUserService userService;

    private IUserInfoService userInfoService;

    // 构造器注入TokenService
    public JwtAuthenticationFilter(ITokenService tokenService, IUserService userService, IUserInfoService userInfoService) {
        this.tokenService = tokenService;
        this.userService = userService;
        this.userInfoService = userInfoService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String requestUri = request.getRequestURI();
        if (!requestUri.startsWith("/chatserver") && !requestUri.endsWith(".html") && !requestUri.endsWith(".ico")) {
            try {
                String token = extractToken(request);
                if (token != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                    Map<String, String> map = tokenService.parseAccessToken(token);
                    if (map == null) {
                        response.setStatus(HttpStatus.UNAUTHORIZED.value());
                        return;
                    }
                    UserInfo userInfo = userInfoService.getById(map.get(Constants.USER_ID));
                    if (userInfo != null) {
                        ReqInfo reqInfo = new ReqInfo();
                        reqInfo.setUserId(Optional.of(map.get(Constants.USER_ID)));
                        ReqInfoOperator.set(reqInfo);
                    }
                    UserDetails userDetails = userService.getById(userInfo.getAuthUserId());
                    if (userDetails != null) {
                        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                                userDetails, null, userDetails.getAuthorities());
                        authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                        SecurityContextHolder.getContext().setAuthentication(authentication);
                    }
                }
            } catch (AuthenticationException e) {
                logger.error("AuthenticationException", e);
                SecurityContextHolder.clearContext();
                response.setStatus(HttpStatus.UNAUTHORIZED.value());
                return;
            }
        }
        filterChain.doFilter(request, response);
    }

    private String extractToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}
