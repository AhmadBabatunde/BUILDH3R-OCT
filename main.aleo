program lgbtq_platform.aleo;

// Import necessary Aleo libraries for cryptography and zero-knowledge proofs
import aleo/cryptography;
import aleo/identity;
import aleo/anonymous_chat;

// A record to represent a user's anonymous identity
record AnonymousUser {
    public identity: field,
    private secret_key: field,
}

// A record to represent a safe space or chatroom
record SafeSpace {
    public space_id: field,
    public user_ids: map<field, bool>,  // Map to store users anonymously
}

// Function to register a new anonymous user
function register_user(private secret_key: field) -> AnonymousUser {
    // Create a public identity based on the secret key using zk-SNARKs
    let identity = hash(secret_key);
    let user = AnonymousUser {
        identity,
        secret_key,
    };
    
    // Output the anonymous user
    return user;
}

// Function to create a new safe space (chatroom)
function create_safe_space(private secret_key: field) -> SafeSpace {
    // Generate a space ID
    let space_id = hash(secret_key);
    
    // Initialize an empty map of users
    let user_ids = map();
    
    // Add the creator of the space to the user list
    map_insert(user_ids, hash(secret_key), true);
    
    // Create the safe space record
    let safe_space = SafeSpace {
        space_id,
        user_ids,
    };
    
    // Output the safe space
    return safe_space;
}

// Function to add a user to a safe space
function add_user_to_space(private secret_key: field, space: SafeSpace) -> SafeSpace {
    // Hash the user's secret key to create their anonymous identity
    let identity = hash(secret_key);
    
    // Add the user to the safe space
    map_insert(space.user_ids, identity, true);
    
    // Return the updated space
    return space;
}

// Function to verify if a user is part of a space
function is_user_in_space(private secret_key: field, space: SafeSpace) -> bool {
    // Hash the user's secret key to create their anonymous identity
    let identity = hash(secret_key);
    
    // Check if the user exists in the space
    let result = map_get(space.user_ids, identity);
    
    // Return true if the user is in the space, otherwise false
    return result;
}
