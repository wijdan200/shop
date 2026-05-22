import React, { useState, useMemo } from 'react';
import { View, Text, StyleSheet, SafeAreaView, KeyboardAvoidingView, Platform, TouchableWithoutFeedback, Keyboard } from 'react-native';
import { observer } from '@legendapp/state/react';
import { authStore$ } from '../state/authStore';
import { LoginViewModel } from '../viewmodels/LoginViewModel';
import { AuthRemoteDataSourceImpl } from '../../data/datasources/AuthRemoteDataSource';
import { AuthRepositoryImpl } from '../../data/repositories/AuthRepositoryImpl';
import { LoginUseCase } from '../../domain/usecases/LoginUseCase';
import { CustomInput } from '../components/CustomInput';
import { CustomButton } from '../components/CustomButton';

// Setup DI (Normally happens in a dedicated DI container)
const dataSource = new AuthRemoteDataSourceImpl();
const repository = new AuthRepositoryImpl(dataSource);
const loginUseCase = new LoginUseCase(repository);
const loginViewModel = new LoginViewModel(loginUseCase);

export const LoginScreen = observer(() => {
    // Local state for forms, Legend state handles global/business state
   
    const [email,setEmail]=useState('');
    const [password,setPassword]=useState('');

     const isButtonDisabled = email !== 'test@test.com'|| password !=='123456';

    const handleLogin = () => {
        Keyboard.dismiss();
        loginViewModel.login(email, password);
    };

    const handleLogout=()=>{
        loginViewModel.logout();
    }

    // Subscribe to specific parts of the state
    const isLoading = authStore$.isLoading.get();
    const error = authStore$.error.get();
    const user = authStore$.user.get();

    if (user) {
        return (
            <View style={styles.centerContainer}>
                <Text style={styles.title}>Welcome back,</Text>
                <Text style={styles.subtitle}>{user.name}</Text>
                <View style={{ width: 200 }}>
                    <CustomButton title="Logout" onPress={handleLogout} />
                </View>
            </View>
        );
    }

    return (
        <SafeAreaView style={styles.container}>
            <KeyboardAvoidingView
                behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
                style={styles.container}
            >
                <TouchableWithoutFeedback onPress={Keyboard.dismiss}>
                    <View style={styles.innerContainer}>
                        <View style={styles.header}>
                            <Text style={styles.title}>Welcome Back</Text>
                            <Text style={styles.subtitle}>Sign in to continue</Text>
                        </View>

                        <View style={styles.form}>
                            <CustomInput
                                label="Email Address"
                                placeholder="Enter your email"
                                keyboardType="email-address"
                                autoCapitalize="none"
                                value={email}
                                onChangeText={setEmail}
                            />

                            <CustomInput
                                label="Password"
                                placeholder="Enter your password"
                                secureTextEntry
                                value={password}
                                onChangeText={setPassword}
                            />

                            {error && <Text style={styles.globalError}>{error}</Text>}

                            <CustomButton
                                title="Sign In"
                                onPress={handleLogin}
                                isLoading={isLoading}
                                disabled={isButtonDisabled}
                            />
                        </View>
                        <View style={styles.footer}>
                            <Text style={styles.footerText}>Don't have an account? <Text style={styles.signUpText}>Sign up</Text></Text>
                        </View>
                    </View>
                </TouchableWithoutFeedback>
            </KeyboardAvoidingView>
        </SafeAreaView>
    );
});

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#FFFFFF',
    },
    centerContainer: {
        flex: 1,
        backgroundColor: '#FFFFFF',
        justifyContent: 'center',
        alignItems: 'center',
        padding: 20,
    },
    innerContainer: {
        flex: 1,
        justifyContent: 'center',
        paddingHorizontal: 24,
    },
    header: {
        marginBottom: 40,
    },
    title: {
        fontSize: 32,
        fontWeight: 'bold',
        color: '#111827',
        marginBottom: 8,
    },
    subtitle: {
        fontSize: 16,
        color: '#6B7280',
    },
    form: {
        width: '100%',
    },
    globalError: {
        color: '#EF4444',
        textAlign: 'center',
        marginTop: 10,
        fontSize: 14,
    },
    footer: {
        marginTop: 32,
        alignItems: 'center',
    },
    footerText: {
        color: '#6B7280',
        fontSize: 14,
    },
    signUpText: {
        color: '#3B82F6',
        fontWeight: 'bold',
    },
});
