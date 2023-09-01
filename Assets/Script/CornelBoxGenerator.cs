using UnityEngine;

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CornelBoxGenerator : MonoBehaviour
{

    static readonly string LeftWallName = "Left Wall";
    static readonly string RightWallName = "Right Wall";
    static readonly string BottomWallName = "Bottom Wall";
    static readonly string TopWallName = "Top Wall";
    static readonly string FarWallName = "Far Wall";
    static readonly float PlaneSize = 10.0f;

    [SerializeField]
    float size = 10.0f;

#pragma warning disable 649
    [SerializeField]
    Material material;

    [SerializeField]
    Material leftMaterial;

    [SerializeField]
    Material rightMaterial;

    [SerializeField]
    Material bottomMaterial;

    [SerializeField]
    Material topMaterial;

    [SerializeField]
    Material farMaterial;

    [ContextMenu("Create Cornel Box")]
    void CreateCornelBox()
    {
        Debug.Log("Create Cornel Box");
        DestroyWalls();

        float halfSize = 0.5f * size;
        float scale = size / PlaneSize;

        CreateWall(
            LeftWallName,
            new Vector3(-halfSize, 0, 0),
            Quaternion.Euler(0, 0, -90),
            new Vector3(scale, scale, scale),
            leftMaterial != null ? leftMaterial : material
        );

        CreateWall(
            RightWallName,
            new Vector3(halfSize, 0, 0),
            Quaternion.Euler(0, 0, 90),
            new Vector3(scale, scale, scale),
            rightMaterial != null ? rightMaterial : material
        );

        CreateWall(
            BottomWallName,
            new Vector3(0, -halfSize, 0),
            Quaternion.Euler(0, 0, 0),
            new Vector3(scale, scale, scale),
            bottomMaterial != null ? bottomMaterial : material
        );

        CreateWall(
            TopWallName,
            new Vector3(0, halfSize, 0),
            Quaternion.Euler(180, 0, 0),
            new Vector3(scale, scale, scale),
            topMaterial != null ? topMaterial : material
        );

        CreateWall(
            FarWallName,
            new Vector3(0, 0, halfSize),
            Quaternion.Euler(-90, 0, 0),
            new Vector3(scale, scale, scale),
            farMaterial != null ? farMaterial : material
        );
    }

    void DestroyWalls()
    {
        DestroyChild(LeftWallName);
        DestroyChild(RightWallName);
        DestroyChild(BottomWallName);
        DestroyChild(TopWallName);
        DestroyChild(FarWallName);
    }

    void DestroyChild(string name)
    {
        var childTransform = transform.Find(name);
        if (childTransform != null)
        {
            GameObject.DestroyImmediate(childTransform.gameObject);
        }
    }

    void CreateWall(string name, Vector3 position, Quaternion rotation, Vector3 scale, Material material)
    {
        var wall = GameObject.CreatePrimitive(PrimitiveType.Plane);
        wall.name = name;
        wall.transform.parent = transform;
        wall.transform.localPosition = position;
        wall.transform.localRotation = rotation;
        wall.transform.localScale = scale;
        if (material != null)
        {
            wall.GetComponent<Renderer>().sharedMaterial = material;
        }
    }
}