import { observable } from '@legendapp/state';
import { User } from '../../domain/entities/User';
//define the global state <variables> for authentication
export const authStore$ = observable({
    user: null as User | null,
    isLoading: false,
    error: null as string | null,
    isAuthenticated: () => !!authStore$.user.get(),
});
