using UnityEngine;
using UnityEngine.VR;
using System.Collections;

public class ShaderToyWorker : MonoBehaviour
{
    public Camera LeftEyeCamera;

    public Camera RightEyeCamera;

    public Material LeftEyeMaterial;

    public Material RightEyeMaterial;

    void Start()
    {

    }

    void Update()
    {
        ApplyProperty(
            LeftEyeMaterial,
            LeftEyeCamera,
            LeftEyeCamera.transform.position,
            LeftEyeCamera.transform.rotation
            );
        ApplyProperty(
            RightEyeMaterial,
            RightEyeCamera,
            RightEyeCamera.transform.position,
            RightEyeCamera.transform.rotation
            );
    }

    void ApplyProperty(Material mat, Camera camera, Vector3 cameraPos, Quaternion cameraRot)
    {
        var vdiff = Mathf.Tan(camera.fieldOfView * 0.5f * Mathf.Deg2Rad) * 2.0f;
        var hdiff = vdiff * camera.aspect;
        mat.SetFloat("_HalfScreenVertical", vdiff);
        mat.SetFloat("_HalfScreenHorizontal", hdiff);
        mat.SetVector("_CameraPos", cameraPos);
        mat.SetVector("_CameraDir", cameraRot * Vector3.forward);
        mat.SetVector("_CameraRight", cameraRot * Vector3.right);
        mat.SetVector("_CameraUp", cameraRot * Vector3.up);
    }
}
