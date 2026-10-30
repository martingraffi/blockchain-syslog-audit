import random

random.seed(42)


def simulate_t1070_attack(logs_sample):
    altered_count = 0
    target_indices = set(random.sample(range(len(logs_sample)), min(5000, len(logs_sample))))
    for idx, log in enumerate(logs_sample):
        if idx in target_indices:
            log['message'] += " [ALTERED_BY_ATTACKER]"
            altered_count += 1
    return logs_sample, altered_count


def verify_merkle_root(original_hash, blockchain_root):
    return original_hash == blockchain_root
