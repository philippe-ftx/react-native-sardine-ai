export function setupSDK({
  clientId,
  sessionKey,
  userIdHash,
  environment,
  flow,
  partnerID,
}: {
  clientId: string;
  sessionKey: string;
  userIdHash?: string;
  enableBehaviorBiometrics?: boolean;
  enableClipboardTracking?: boolean;
  environment: "production" | "sandbox";
  flow?: string;
  partnerID?: string;
}): Promise<void>;

export function submitData(): Promise<void>;
export function updateOptions({ flow, sessionKey, userIdHash }: {
  flow?: string;
  sessionKey?: string;
  userIdHash?: string;
}): Promise<void>;
